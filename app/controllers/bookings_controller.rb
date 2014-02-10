class BookingsController < ApplicationController
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new
    @room_types = RoomType.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(params[:booking].except(:room,:contact))
    @rooms_with_given_room_type = Room.where(:room_type_id => params[:booking][:room][:room_type_id]).includes(:booking)
    @occupied = 0
    if !@rooms_with_given_room_type.blank?
      @rooms_with_given_room_type.each.with_index(1) do |room, count|
        if (Date.civil(params["booking"]["check_in(1i)"].to_i, params["booking"]["check_in(2i)"].to_i, params["booking"]["check_in(3i)"].to_i)..Date.civil(params["booking"]["check_out(1i)"].to_i, params["booking"]["check_out(2i)"].to_i, params["booking"]["check_out(3i)"].to_i)).overlaps?(room.booking.check_in..room.booking.check_out)
          @occupied = count
        end
      end
    end
    @total_rooms = RoomType.where(:id => params[:booking][:room][:room_type_id]).select("room_count")
    if (@total_rooms[0][:room_count] > @occupied)
      if @booking.save
        @room = @booking.rooms.create(params[:booking][:room])
        @contact = @booking.create_contact(params[:booking][:contact])
        if (@room.save and @contact.save)
          redirect_to @booking, notice: 'Booking was successfully created.'
        else
          @room.destroy
          @contact.destroy
          @booking.destroy
          render action: "new"
        end
      else
        render action: "new"
      end
    else
      render action: "new", notice: 'No Room Available.'
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = Booking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :ok }
    end
  end
end
