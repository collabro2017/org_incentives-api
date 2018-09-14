module ExerciseOrderHelper
  def create_exercise_window_body
    {
        :startTime => "2016-01-01T00:00:00.000Z",
        :endTime => "2018-01-01T00:00:00.000Z"
    }
  end

  def create_exercise_window_with_api(tenant_id)
    post "/api/v1/exercise_windows?tenantId=#{tenant_id}", create_exercise_window_body
  end

  def delete_exercise_window_with_api(tenant_id, exercise_window_id)
    delete "/api/v1/exercise_windows/#{exercise_window_id}?tenantId=#{tenant_id}"
  end
end