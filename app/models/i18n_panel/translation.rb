module I18nPanel
  class Translation
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Conversion

    SKIPPED_KEYS = %w[
      date time number support activerecord.errors.models.doorkeeper/application
    ].freeze

    attr_reader :key, :value, :locale

    def initialize(attributes)
      @key = attributes[:key]
      @value = attributes[:value]
      @locale = attributes[:locale]
    end

    def self.all
      backend = I18n.backend.translations
      locales = backend.keys
      translations = []
      locales.each do |locale|
        translation_lookup(full_key: locale, value: backend[locale], locale: locale, collection: translations)
      end
      translations
    end

    def self.translation_lookup(value:, full_key:, locale:, collection: [])
      normalized_key = full_key.to_s.sub("#{locale}.", '')
      return if SKIPPED_KEYS.include?(normalized_key)

      if value.is_a?(Hash)
        value.each do |h_key, h_value|
          translation_lookup(full_key: "#{full_key}.#{h_key}", value: h_value, locale: locale, collection: collection)
        end
      else
        collection << Translation.new({ locale: locale, key: normalized_key, value: value })
      end
      collection
    end

    def self.find_by(key:, locale: I18n.locale)
      key = normalize_key(key)
      value = I18n.t(key, locale: locale)
      new(key: key, value: value, locale: locale)
    end

    def self.normalize_key(key)
      key.to_s.gsub('__', '.')
    end

    def related_translations
      I18n.backend.translations.keys.map do |locale|
        value = I18n.backend.send(:lookup, locale, key)
        Translation.new(key: key, value: value, locale: locale.to_s)
      end
    end

    def to_param
      parameterized_key
    end

    def parameterized_key
      key.to_s.gsub('.', '__')
    end
  end
end
