require "active_support/concern"
require "json"

module AiErrorClip
  module ControllerExtension
    extend ActiveSupport::Concern

    included do
      if Rails.env.development?
        rescue_from StandardError, with: :ai_error_clip_handle_standard_error
      end
    end

    private

    # シンプルエラー画面を表示するか通常のエラーに任せるか判断する
    def ai_error_clip_handle_standard_error(exception)
      if Rails.env.development?
        ai_error_clip_render_simple_error(exception)
      else
        raise exception
      end
    end

    # エラー内容を整形してAI向けのテンプレートを描画する
    def ai_error_clip_render_simple_error(exception)
      # GETクエリも含めた送信データをまとめる
      request_payload = ai_error_clip_formatted_request_body

      @ai_error_clip_error = {
        class: exception.class.name,
        message: exception.message,
        backtrace: Array(exception.backtrace).first(10),
        path: request.path,
        method: request.method,
        body: request_payload,
        context: ai_error_clip_request_context
      }

      render template: "ai_error_clip/simple_error", status: :internal_server_error, layout: false
    end

    # リクエストに関する追加情報をまとめる
    def ai_error_clip_request_context
      {
        environment: Rails.env,
        rails_version: Rails.version,
        ruby_version: RUBY_VERSION,
        request_id: request.request_id,
        controller: controller_name,
        action: action_name,
        referer: request.referer,
        user_agent: request.user_agent
      }.compact
    end

    # リクエストパラメーターをJSON風に整形する（GETも含む）
    def ai_error_clip_formatted_request_body
      raw_params = ai_error_clip_capture_raw_params
      return request.raw_post.presence unless raw_params.present?

      begin
        JSON.pretty_generate(raw_params)
      rescue StandardError
        raw_params.inspect
      end
    end

    # Strong Parametersを安全なハッシュに変換する
    def ai_error_clip_capture_raw_params
      params_hash = params.to_unsafe_h.deep_dup
      %w[controller action utf8 authenticity_token commit].each do |key|
        params_hash.delete(key)
        params_hash.delete(key.to_sym)
      end
      ai_error_clip_sanitize_param_values(params_hash)
    rescue StandardError
      request.filtered_parameters.except(:controller, :action, "controller", "action")
    end

    # ファイルなどの値を文字列情報にそろえる
    def ai_error_clip_sanitize_param_values(value)
      case value
      when ActionDispatch::Http::UploadedFile
        {
          name: value.original_filename,
          type: value.content_type,
          size: value.size
        }
      when Hash
        value.transform_values { |v| ai_error_clip_sanitize_param_values(v) }
      when ActionController::Parameters
        ai_error_clip_sanitize_param_values(value.to_unsafe_h)
      when Array
        value.map { |v| ai_error_clip_sanitize_param_values(v) }
      else
        value
      end
    end
  end
end
