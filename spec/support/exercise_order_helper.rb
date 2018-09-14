module ExerciseOrderHelper
  def create_exercise_order_body
    {
        :exerciseType => "EXERCISE_AND_HOLD"
    }
  end
  def create_exercise_order tenant_id, employee_id, vesting_events
    #post "/api/v1/exercise_order", create_exercise_order_body
    tenant = Tenant.find tenant_id
    eo = tenant.exercise_orders.create!({ status: "CREATED", employee_id: employee_id, exerciseType: "EXERCISE_AND_HOLD", exercise_order_lines: create_exercise_order_lines(vesting_events) })
    eo.id
  end

  def create_exercise_order_with_api(body)
    post "/api/v1/exercise_order", body
  end

  def update_exercise_order tenant_id, order_id, body
    put "/api/v1/exercise_order/#{order_id}?tenantId=#{tenant_id}", body
  end

  def get_exercise_order_with_api(tenant_id, include_vesting_event)
    get "/api/v1/exercise_order?tenantId=#{tenant_id}#{include_vesting_event ? "&include_vesting_event=true" : ""}"
  end

  def create_exercise_order_lines(vesting_events)
    vesting_events.map { |ve|
      ExerciseOrderLine.new(:vesting_event_id => ve["id"], :exercise_quantity => 10)
    }
  end
end