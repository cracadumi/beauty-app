class BookingMailer < ApplicationMailer
  def confirmed_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'Your booking has been confirmed')
  end

  def confirmed_beautician(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @beautician = @booking.beautician
    mail(to: @beautician.email,
         content_type: 'text/html',
         subject: 'Your booking has been confirmed')
  end

  def expired_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'Your request has expired')
  end

  def refused_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'Your request has been refused')
  end

  def pending_canceled_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'The request has been canceled')
  end

  def pending_canceled_beautician(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @beautician = @booking.beautician
    mail(to: @beautician.email,
         content_type: 'text/html',
         subject: 'The request has been canceled')
  end

  def accepted_canceled_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'The appointment has been canceled')
  end

  def accepted_canceled_beautician(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @beautician = @booking.beautician
    mail(to: @beautician.email,
         content_type: 'text/html',
         subject: 'The appointment has been canceled')
  end

  def rescheduled_canceled_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'The reschedule request has been canceled')
  end

  def rescheduled_canceled_beautician(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @beautician = @booking.beautician
    mail(to: @beautician.email,
         content_type: 'text/html',
         subject: 'The reschedule request has been canceled')
  end

  def reschedule_user(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @user = @booking.user
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'The request has been rescheduled')
  end

  def reschedule_beautician(booking_id)
    @booking = Booking.find_by(id: booking_id)
    @beautician = @booking.beautician
    mail(to: @beautician.email,
         content_type: 'text/html',
         subject: 'The request has been rescheduled')
  end
end
