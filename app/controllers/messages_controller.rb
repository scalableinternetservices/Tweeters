class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:conversation,:edit, :update]
  helper :all

  # GET /messages
  def index
  end


  # def get_all_users
  #   user_cache = Rails.cache.read("user/conversations/#{current_user.id}")
  #   if(user_cache == nil)
  #     user_cache = Message.where(to_user: current_user.id).or(Message.where(from_user: current_user.id)).map{ |record|
  #       if record.to_user.to_i == current_user.id
  #         record.from_user
  #       elsif record.from_user.to_i == current_user.id
  #         record.to_user
  #       end
  #     }.uniq.map { |user_id|
  #     User.where(id: user_id).first  }
  #     Rails.cache.write("user/conversations/#{current_user.id}", user_cache, expires_in: 20.minute)
  #     user_cache
  #   else
  #     user_cache
  #   end
  #   Rails.cache.fetch("user/conversations/#{current_user.id}/#{User.maximum(:id)}") do
  # # Only executed if the cache does not already have a value for this key
  #       puts "Crunching the numbers..."
  #       Message.where(to_user: current_user.id).or(Message.where(from_user: current_user.id)).map{ |record|
  #         if record.to_user.to_i == current_user.id
  #           record.from_user
  #         elsif record.from_user.to_i == current_user.id
  #           record.to_user
  #         end
  #       }.uniq.map { |user_id|
  #       User.where(id: user_id).first }
  #   end
  # end

  def conversation
    @other_id =  params[:other]
    # @user_all = get_all_users
    @user_all = Message.where(to_user: current_user.id).or(Message.where(from_user: current_user.id)).map{ |record|
      if record.to_user.to_i == current_user.id
        record.from_user
      elsif record.from_user.to_i == current_user.id
        record.to_user
      end
    }.uniq.map { |user_id|
    User.where(id: user_id).first  }

    @other_user = User.find_by(id: @other_id)

    @chatMessages_ = Message.where(to_user: @other_id, from_user: current_user.id)
    .or(Message.where(from_user: @other_id, to_user: current_user.id))
    .paginate(:page => params[:page])


  end


  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  def create
    @message = Message.new(message_params)
    @finaldata  = []

    if @message.save
      redirect_to (request.referer.nil? ? @message: request.referer)#, notice: 'Message was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: 'Message was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content, :to_user, :from_user)
    end
end
