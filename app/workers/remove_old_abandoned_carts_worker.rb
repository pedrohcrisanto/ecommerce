class RemoveOldAbandonedCartsWorker
  include Sidekiq::Worker

  LIMIT_ABANDONED_DAYS = 7.days.ago.freeze

  queue_as :default
  def perform
    Cart.where.not(abandoned_at: nil)
        .where("abandoned_at < ?", LIMIT_ABANDONED_DAYS)
        .in_batches(of: 1000) do |batch|
      batch.delete_all
    end

    Rails.logger.info("[RemoveOldAbandonedCartsJob] Remoção concluída.")
  end
end
