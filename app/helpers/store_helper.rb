module StoreHelper
  def get_credit_value(user_id)
    user = User.find_by_id(user_id)
    user.credit
  end
end
