require "rails/railtie"
require_relative "controller_extension"

module AiErrorClip
  class Railtie < ::Rails::Railtie
    initializer "ai_error_clip.configure_controller" do
      ActiveSupport.on_load(:action_controller_base) do
        # Railsコントローラーでgemの機能を使えるようにする
        include AiErrorClip::ControllerExtension

        # gem内のビューを描画対象に追加する
        append_view_path File.expand_path("../../app/views", __dir__)
      end
    end
  end
end
