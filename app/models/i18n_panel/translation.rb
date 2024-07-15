module I18nPanel
  class Translation
    extend ActiveModel::Naming
    include ActiveModel::Model
    include ActiveModel::Conversion

    PLURAL_FORMS = %[zero one few many other].freeze
    PLURAL_FORMS_CONFIG = {
      ru: %w[zero one few many other],
      lt: %w[zero one few many other]
    }.freeze

    SKIPPED_KEYS = %w[
      date time datetime number numbers support doorkeeper i18n
      activerecord.errors.models.doorkeeper/application faker i18n_tasks
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
      # Use a hash to store only unique key translations
      translations = {}
      locales.each do |locale|
        translation_lookup(full_key: locale, value: backend[locale], locale: locale, collection: translations)
      end
      # Return only the Translation objects
      translations.values
    end

    def self.translation_lookup(value:, full_key:, locale:, collection: {})
      normalized_key = full_key.to_s.sub("#{locale}.", '')
      return if SKIPPED_KEYS.include?(normalized_key)

      if value.is_a?(Hash)
        value.each do |h_key, h_value|
          translation_lookup(full_key: "#{full_key}.#{h_key}", value: h_value, locale: locale, collection: collection)
        end
      else
        return if collection[normalized_key].present?

        collection[normalized_key] = Translation.new({ locale: locale, key: normalized_key, value: value })
      end
      collection.values
    end

    def self.find_by(key:, locale: I18n.locale)
      value = I18n.t(key, locale: locale)
      new(key: key, value: value, locale: locale)
    end

    def self.escape_key(key)
      key.gsub('.', '-').gsub('/', '--')
    end

    def self.unescape_key(key)
      key.gsub('-', '.').gsub('--', '/')
    end

    def self.plural_forms(locale)
      PLURAL_FORMS_CONFIG.fetch(locale.to_sym, %w[zero one other])
    end

    def related_translations
      arr = []
      locales = I18n.backend.translations.keys
      locales.each do |locale|
        last_part = key.split('.').last
        # Skip if plural form is not present for the locale
        next if self.class::PLURAL_FORMS.include?(last_part) && self.class.plural_forms(locale).exclude?(last_part)

        value = I18n.backend.send(:lookup, locale, key)
        arr << Translation.new(key: key, value: value, locale: locale.to_s)
      end
      arr
    end

    def to_param
      escaped_key
    end

    def escaped_key
      self.class.escape_key(key)
    end
  end
end
