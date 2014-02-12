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
    @rooms = @booking.rooms

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new
    @booking.build_contact
    @room_types = RoomType.all

    respond_to do |format|
      format.html { render action: 'new' } # new.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
    @booking.build_contact if @booking.contact.nil?
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking =  Booking.new(params[:booking])
    @room_types = RoomType.all
    logger.debug(@booking.id)
    @booking.amount = 0
    if @booking.save
      if !params[:rooms].blank?
        params[:rooms].each_with_index do |new_room, i|
          @room_type = @room_types.detect {|room_type| room_type.id == new_room[:room_type_id].to_i }
          @rooms_with_given_room_type = Room.where(:room_type_id => new_room[:room_type_id]).includes(:booking)
          @occupied = 0
          if !@rooms_with_given_room_type.blank?
            @occupied = @rooms_with_given_room_type.count {|room| (@booking.check_in..@booking.check_out).overlaps?(room.booking.check_in..room.booking.check_out) }
          end
          if @room_type.room_count > @occupied
            @room = @booking.rooms.create(new_room)
            if i == params[:rooms].count-1
              logger.info "Completed booking all rooms"
               redirect_to "/bookings/#{@booking.id}", notice: 'Booking created successfully!'
            end
          else
            logger.info "#{params[:rooms].count-i} rooms cannot be booked"
            redirect_to "/bookings/#{@booking.id}", notice: "#{i} Rooms Booked. Cannot Book remaining rooms because Rooms of selected room types are Booked "
            break
          end
        end
      else
        @booking.destroy
        redirect_to bookings_path
      end
    else
      render action: 'new'
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

  # POST /bookings/:booking_id/new
  def add_room
    @booking = Booking.new(params[:booking].except(:contact))
    @room_types = RoomType.all
    if !params[:rooms].blank?
      @no_of_rooms = params[:rooms].count
    else
      @no_of_rooms = nil
    end
    render 'new'
  end

end
