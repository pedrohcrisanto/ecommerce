class MarkAbandonedCartsWorker
  include Sidekiq::Worker

  queue_as :default

  LIMIT_ABANDONED_HOURS =  3.hours.ago.freeze

  def perform
    total_marked = 0

    Cart.where(abandoned_at: nil)
        .where("updated_at < ?", LIMIT_ABANDONED_HOURS)
        .in_batches(of: 10_000) do |batch|
      updated = batch.update_all(abandoned_at: Time.current)
      total_marked += updated
      Rails.logger.info("[MarkAbandonedCartsJob] Marcados #{updated} carrinhos neste lote. Total até agora: #{total_marked}")
    end

    Rails.logger.info("[MarkAbandonedCartsJob] Concluído. Total de carrinhos marcados como abandonados: #{total_marked}")
  end
end
