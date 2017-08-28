class AbilityController < ApplicationController
  def initialize
    # Always performed
    can :access, :ckeditor   # needed to access Ckeditor filebrowser

    # Performed checks for actions:
    can [:read, :create, :destroy], Ckeditor::Picture
    can [:read, :create, :destroy], Ckeditor::AttachmentFile
  end
end
