module OrdersHelper
  def to_param
    user_facing_id
  end

  private

  def generate_user_facing_id
    self.user_facing_id ||= SecureRandom.uuid[0..7]
  end
end