json.extract! settings_beautician, :id, :instant_booking, :advance_booking,
              :mobile, :office

if settings_beautician.office? && settings_beautician.office_address
  json.office_address do
    json.partial! settings_beautician.office_address
  end
end

if settings_beautician.advance_booking?
  json.availabilities do
    json.partial! 'api/v1/availabilities/availability',
                  collection: settings_beautician.availabilities,
                  as: :availability
  end
end
