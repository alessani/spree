module Spree
  module PromotionHandler
    class Page
      attr_reader :order, :path

      def initialize(order, path)
        @order = order
        @path = path.gsub(/\A\//, '')
      end

      def activate
        if promotion && promotion.eligible?(order)
          if promotion.activate(:order => order)
            order.update_totals
            order.updater.persist_totals
          end
        end
      end

      private

        def promotion
          @promotion ||= Promotion.active.find_by(:path => path)
        end
    end
  end
end