class DailyDigestService
  def send_digest
    return if Question.created_prev_day.empty?

    User.find_each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
