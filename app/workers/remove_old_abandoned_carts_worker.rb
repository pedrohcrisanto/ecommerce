class RemoveOldAbandonedCartsWorker
  include Sidekiq::Worker

  LIMIT_ABANDONED_DAYS = 7.days.ago.freeze

  queue_as :default
  def perform
    total_removed = 0

    Cart.where.not(abandoned_at: nil)
        .where("abandoned_at < ?", LIMIT_ABANDONED_DAYS)
        .find_each(batch_size: 1000) do |cart|
      cart.destroy
      total_removed += 1
    end

    Rails.logger.info("[RemoveOldAbandonedCartsJob] Remoção concluída. Total de carrinhos removidos com callbacks: #{total_removed}")
  end
end
