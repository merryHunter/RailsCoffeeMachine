module StoreHelper
  def get_credit_value(user_id)
    logger.debug("GET_CREDIT_VALUE")
    user = User.find_by_id(user_id)
    unless user.nil?
      user.credit
    end
  end
end
