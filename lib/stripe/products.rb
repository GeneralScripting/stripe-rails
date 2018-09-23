module Stripe
  module Products
    include ConfigurationBuilder

    configuration_for :product do
      attr_accessor :name,
                    :type,
                    :active,
                    :attributes,
                    :description,
                    :caption,
                    :metadata,
                    :shippable,
                    :url,
                    :statement_descriptor

      validates_presence_of :name, :type

      validates :active, :shippable, inclusion: { in: [true, false] }, allow_nil: true
      validates :type, inclusion: { in: %w(service good) }
      validates :caption, :description, :shippable, :url, absence: true, unless: :good?
      validates :statement_descriptor, absence: true, unless: :service?

      private
      def good?
        type == 'good'
      end

      def service?
        type == 'service'
      end

      def create_options
        {
          name: name,
          type: type,
          active: active,
          attributes: attributes,
          description: description,
          caption: caption,
          metadata: metadata,
          shippable: shippable,
          url: url,
          statement_descriptor: statement_descriptor
        }.delete_if{|_, v| v.nil? }
      end
    end
  end
end