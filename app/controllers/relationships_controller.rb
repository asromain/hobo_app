class RelationshipsController < ApplicationController

  hobo_model_controller

  auto_actions :all, except: [:new, :create]

end
