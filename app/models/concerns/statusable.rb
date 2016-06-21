module Statusable
  extend ActiveSupport::Concern

  included do
    include AASM
    enum status: { pending: 0, accepted: 1, expired: 2, refused: 3,
                   completed: 4, canceled: 5, rescheduled: 6 }

    # 0 -> 1 : send notification to self.user "Your booking has been confirmed",
    # email to both
    # 0 -> 2 : "your request has expired", notification and email to user
    # 0 -> 3 : "your request has been refused", notification and email to user
    # 0 -> 5 : to beautician "the request has been canceled"
    # 0 -> 6 : email and notification to user "the request has been rescheduled"
    # 1 -> 5 : notification and email to both "the appointment has
    # been canceled"
    # 6 -> 1 : datetime should become the requested_date
    # 6 -> 5 : notification and email to beautician "the reschedule request has
    # been canceled"
    aasm column: :status, enum: true do
      state :pending, initial: true
      state :accepted
      state :expired
      state :refused
      state :completed
      state :canceled
      state :rescheduled

      after_all_events :run_callback

      event :accept do
        transitions from: [:pending, :rescheduled], to: :accepted
      end
      event :expire do
        transitions from: :pending, to: :expired
      end
      event :refuse do
        transitions from: :pending, to: :refused
      end
      event :complete do
        transitions from: :accepted, to: :refused
      end
      event :cancel do
        transitions from: [:pending, :accepted, :rescheduled], to: :canceled
      end
      event :reschedule do
        transitions from: :pending, to: :rescheduled
      end
    end
  end

  def run_callback
    Rails.logger.info "changing from #{aasm.from_state} to #{aasm.to_state}
                       (event: #{aasm.current_event})"
    callback_name = "#{aasm.from_state}_to_#{aasm.to_state}_callback"
    send(callback_name) if respond_to? callback_name
  end

  def pending_to_accepted_callback
    BookingMailer.confirmed_user(self).deliver_now
    BookingMailer.confirmed_beautician(self).deliver_now
    # TODO: send notification to user: Your booking has been confirmed
  end

  def pending_to_expired_callback
    BookingMailer.expired_user(self).deliver_now
    # TODO: send notification to user: your request has expired
  end

  def pending_to_refused_callback
    BookingMailer.refused_user(self).deliver_now
    # TODO: send notification to user: your request has been refused
  end

  def pending_to_canceled_callback
    BookingMailer.pending_canceled_beautician(self).deliver_now
    # TODO: send notification to beautician: the request has been canceled
  end

  def pending_to_rescheduled_callback
    BookingMailer.reschedule_user(self).deliver_now
    BookingMailer.reschedule_beautician(self).deliver_now
    # TODO: send notification to both: the request has been rescheduled
  end

  def accepted_to_canceled_callback
    BookingMailer.accepted_canceled_user(self).deliver_now
    BookingMailer.accepted_canceled_beautician(self).deliver_now
    # TODO: send notification to both: the appointment has been canceled
  end

  def rescheduled_to_accepted_callback
    # BookingMailer.rescheduled_user(self).deliver_now
    # BookingMailer.rescheduled_beautician(self).deliver_now
    # TODO: send notification to user: ???
  end

  def rescheduled_to_canceled_callback
    BookingMailer.rescheduled_canceled_user(self).deliver_now
    BookingMailer.rescheduled_canceled_beautician(self).deliver_now
    # TODO: send notification to both: the reschedule request has been canceled
  end
end
