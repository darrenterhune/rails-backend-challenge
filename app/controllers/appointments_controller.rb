class AppointmentsController < ApplicationController
  # POST /appointments
  # Params: client_id, provider_id, starts_at, ends_at
  def create
    availability = Availability.where(provider_id: appointment_params[:provider_id]).between_dates(params.dig(:appointment, :starts_at), params.dig(:appointment, :ends_at)).first
    appointment = Appointment.new(appointment_params.merge!(availability_id: availability&.id))

    if appointment.save
      render(json: appointment, status: :created)
    else
      render(json: appointment.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /appointments/:id
  # Bonus: cancel an appointment instead of deleting
  def destroy
    appointment = Appointment.find(params[:id])
    appointment.soft_delete!
    render(json: appointment, status: :ok)
  end

  private

  def appointment_params
    params.require(:appointment).permit(%i[provider_id client_id])
  end
end
