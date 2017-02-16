class EventsController < ApplicationController

  before_action :set_event, :only => [:show, :edit, :update, :destroy]

  # GET /events/index
  # GET /events
  def index
    @events = Event.page( params[:page] ).per(10)
  end

  def show
    @page_title = @event.name
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /events/
  def create
    @event = Event.new( event_params )

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

  private

  def set_event
    @event = Event.find( params[:id] )
  end

  def event_params
    params.require(:event).permit(:name, :description)
  end

end
