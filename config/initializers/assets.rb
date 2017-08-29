# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( home/* )
Rails.application.config.assets.precompile += %w( home/index.js )
Rails.application.config.assets.precompile += %w( home/index.css )
Rails.application.config.assets.precompile += %w( zone/main.css )
Rails.application.config.assets.precompile += %w( zone/main.js )
Rails.application.config.assets.precompile += %w( zone/edit.css )
Rails.application.config.assets.precompile += %w( topic/main.css )
Rails.application.config.assets.precompile += %w( topic/main.js )
Rails.application.config.assets.precompile += %w( users/* )
Rails.application.config.assets.precompile += %w( mail/* )
Rails.application.config.assets.precompile += %w( session/* )
Rails.application.config.assets.precompile += %w( ckeditor/*)
Rails.application.config.assets.precompile += %w( base.js )
Rails.application.config.assets.precompile += %w( session/new.css )
