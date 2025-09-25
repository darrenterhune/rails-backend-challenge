class AvailabilitySync
  def initialize(client: CalendlyClient.new, end_date: DateTime.current.end_of_year.to_date)
    @availabilities = []
    @client = client
    @end_date = end_date
  end

  def call(provider_id:)
    weeks = ((end_date - current_date) / 7).ceil

    client.fetch_slots(provider_id).each do |slot|
      start_day = slot["starts_at"]["day_of_week"].downcase
      start_time = slot["starts_at"]["time"]
      end_day = slot["ends_at"]["day_of_week"].downcase
      end_time = slot["ends_at"]["time"]

      weeks.times do |week_offset|
        week_date = current_date + (week_offset * 7)
        next_date = if start_day == current_date.strftime("%A").downcase && week_offset == 0
                      slot_time = time_parse("#{week_date} #{start_time}")
                      slot_time > current_date ? week_date : week_date.next_occurring(start_day.to_sym)
        else
                      week_date.next_occurring(start_day.to_sym)
        end

        next if next_date > end_date

        starts_at = time_parse("#{next_date} #{start_time}")

        end_date_for_slot = end_day == start_day ? next_date : next_date.next_occurring(end_day.to_sym)
        ends_at = time_parse("#{end_date_for_slot} #{end_time}")

        availabilities << {
          provider_id: slot["provider_id"],
          starts_at: starts_at,
          ends_at: ends_at,
          source: slot["source"]
        }
      end
    end

    create_data_with(availabilities)
  end

  private

  attr_reader :availabilities, :client, :end_date

  def current_date
    @current_date ||= DateTime.current.to_date
  end

  def time_parse(time)
    Time.zone.parse(time)
  end

  def create_data_with(availabilities)
    Availability.upsert_all(availabilities, record_timestamps: true) unless availabilities.empty?
  end
end
