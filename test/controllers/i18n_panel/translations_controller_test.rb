require 'test_helper'

module I18nPanel
  class TranslationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @translation = i18n_panel_translations(:one)
    end

    test "should get index" do
      get translations_url
      assert_response :success
    end

    test "should get new" do
      get new_translation_url
      assert_response :success
    end

    test "should create translation" do
      assert_difference('Translation.count') do
        post translations_url, params: { translation: { key: @translation.key, locale: @translation.locale, value: @translation.value } }
      end

      assert_redirected_to translation_url(Translation.last)
    end

    test "should show translation" do
      get translation_url(@translation)
      assert_response :success
    end

    test "should get edit" do
      get edit_translation_url(@translation)
      assert_response :success
    end

    test "should update translation" do
      patch translation_url(@translation), params: { translation: { key: @translation.key, locale: @translation.locale, value: @translation.value } }
      assert_redirected_to translation_url(@translation)
    end

    test "should destroy translation" do
      assert_difference('Translation.count', -1) do
        delete translation_url(@translation)
      end

      assert_redirected_to translations_url
    end
  end
end
