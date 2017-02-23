class EventsController < ApplicationController

  before_action :authenticate_user!, expect: [:index]

  before_action :set_event, :only => [:show, :edit, :update, :destroy, :dashboard]

  # GET /events/index
  # GET /events
  def index

    prepare_variables_for_index_template

    @events = @events.page( params[:page] ).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml {
        render :xml => @events.to_xml
      }
      format.json {
        render :json => @events.to_json
      }
      format.atom {
        @feed_title = "My event list"
      } # index.atom.builder
    end

  end

  def latest
    @events = Event.order("id DESC").limit(5)
  end

  def show
    respond_to do |format|
      format.html { @page_title = @event.name } # show.html.erb
      format.xml # show.xml.builder
      format.json { render :json => { id: @event.id, name: @event.name}.to_json }
    end
  end

  def dashboard

  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /events/
  def create
    @event = Event.new( event_params )

    @event.user = current_user

    if @event.save

      flash[:notice] = "新增成功"

      redirect_to events_path
    else
      render :action => :new # new.html.erb
    end
  end

  # GET /events/:id/edit
  def edit
    @event = Event.find( params[:id] )
  end

  # PATCH /events/:id
  def update
    if @event.update( event_params )

      flash[:notice] = "編輯成功"

      redirect_to event_path(@event)
    else
      render :action => :edit # edit.html.erb
    end
  end

  # DELETE /event/:id
  def destroy
    @event.destroy

    flash[:alert] = "刪除成功"

    redirect_to events_path
  end

  def bulk_update
    ids = Array( params[:ids] )
    events = ids.map { |i| Event.find_by_id(i) }.compact

    if params[:commit] == "Delete"
      events.each { |e| e.destroy }
    elsif params[:commit] == "Publish"
      events.each { |e| e.update( status: "publish") }
    end

    redirect_to :back
  end

  private

  def set_event
    @event = Event.find( params[:id] )
  end

  def event_params
    params.require(:event).permit(:name, :description, :status, :group_ids => [])
  end

  def prepare_variables_for_index_template
    if params[:keyword]

      @events = Event.where( [ "name like ?", "%#{params[:keyword]}%" ] )
    else
      @events = Event.all
    end

    if params[:order]
      sort_by = (params[:order] == "name")? "name" : "id"
      @events = @events.order(sort_by)
    end
  end

end
