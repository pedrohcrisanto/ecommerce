class MarkAbandonedCartsWorker
  include Sidekiq::Worker

  queue_as :default

  LIMIT_ABANDONED_HOURS =  3.hours.ago.freeze

  def perform
    Cart.where(abandoned_at: nil)
        .where("updated_at < ?", LIMIT_ABANDONED_HOURS)
        .in_batches(of: 1000) do |batch|
      batch.update_all(abandoned_at: Time.current)
    end

    Rails.logger.info("[MarkAbandonedCartsJob] Concluído.")
  end
end
