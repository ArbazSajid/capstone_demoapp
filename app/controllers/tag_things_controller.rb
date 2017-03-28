class TagThingsController < ApplicationController
  include ActionController::Helpers
  helper ThingsHelper
  wrap_parameters :tag_thing, include: ["tag_id", "thing_id"]
  before_action :get_thing, only: [:index, :update, :destroy]
  before_action :get_tag, only: [:tag_things]
  before_action :get_tag_thing, only: [:update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  after_action :verify_authorized
  #after_action :verify_policy_scoped, only: [:linkable_things]

  def index
    authorize @thing, :get_tags?
    @tag_things = @thing.tag_things.with_value
  end

  def tag_things
    authorize @tag, :get_things?
    @tag_things=@tag.tag_things.with_name
    render :index 
  end

  def linkable_things
    authorize Thing, :get_linkables?
    tag = Tag.find(params[:tag_id])
    #@things=policy_scope(Thing.not_linked(image))
    #need to exclude admins from seeing things they cannot link
    @things=Thing.no_tags(tag)
    @things=ThingPolicy::Scope.new(current_user,@things).user_roles(true,false)
    @things=ThingPolicy.merge(@things)
    render "things/index"
  end

  def create
    tag_thing = TagThing.new(tag_thing_create_params.merge({
                                  :tag_id=>params[:tag_id],
                                  :thing_id=>params[:thing_id],
                                  }))
    thing=Thing.where(id:tag_thing.thing_id).first
    if !thing
      full_message_error "cannot find thing[#{params[:thing_id]}]", :bad_request
      skip_authorization
    elsif !Tag.where(id:tag_thing.tag_id).exists?
      full_message_error "cannot find tag[#{params[:tag_id]}]", :bad_request
      skip_authorization
    else
      authorize thing, :add_tag?
      tag_thing.creator_id=current_user.id
      if tag_thing.save
        head :no_content
      else
        render json: {errors:@tag_thing.errors.messages}, status: :unprocessable_entity
      end
    end
  end

  def update
    authorize @thing, :update_tag?
    if @tag_thing.update(tag_thing_update_params)
      head :no_content
    else
      render json: {errors:@tag_thing.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @thing, :remove_tag?
    @tag_thing.destroy
    head :no_content
  end

  private
    def get_thing
      @thing ||= Thing.find(params[:thing_id])
    end
    def get_tag
      @tag ||= Tag.find(params[:tag_id])
    end
    def get_tag_thing
      @tag_thing ||= TagThing.find(params[:id])
    end

    def tag_thing_create_params
      params.require(:tag_thing).tap {|p|
          #_ids only required in payload when not part of URI
          p.require(:tag_id)    if !params[:tag_id]
          p.require(:thing_id)    if !params[:thing_id]
        }.permit(:tag_id, :thing_id)
    end
    def tag_thing_update_params
      params.require(:tag_thing).permit()
    end
end
