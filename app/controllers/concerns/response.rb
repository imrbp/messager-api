module Response
  def root_key
    :data
  end

  def json_response(object, status = :ok)
    render json: { root_key.to_s => object.as_json }, status: status
  end
end
