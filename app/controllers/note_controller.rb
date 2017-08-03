class NoteController < ApplicationController
  before_action :pre_action
  before_action :require_content, only: [:edit, :delete, :update]
  def main
  end
end


