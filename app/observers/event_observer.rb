class EventObserver < ActiveRecord::Observer

  def after_create event
    log(event)
    calculate_achievements_for! event
  end

  private

  def log(event)
    Rails.logger.info "New event: #{event.inspect}"
  end

  def achievement_calculators
    [
      AchievementCalculator::FirstTime,
      AchievementCalculator::GithubPush,
      AchievementCalculator::JenkinsGreenJob,
      AchievementCalculator::MingPongVictory,
      AchievementCalculator::TwitterMention
    ]
  end

  def calculate_achievements_for! event
    achievement_calculators.each do |calculator|
      calculator.new(event).calculate!
    end
  end
end
