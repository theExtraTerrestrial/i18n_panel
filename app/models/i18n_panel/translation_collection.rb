module I18nPanel
  class TranslationCollection
    def initialize(translations)
      @translations = translations
    end

    def by_locale(locale)
      @translations[locale.to_sym]
    end
  end
end
