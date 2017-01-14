class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @entry = current_user.entries.build(title: '', content: '')
    if @entry.save
      redirect_to edit_path(:entry_id => @entry.id)
    else
      render 'static_pages/home'
    end
  end

  def edit
    @entry = current_user.entries.find(params[:entry_id])
  end

  def update
    @entry = current_user.entries.find(params[:id])
    if @entry.update_attributes(entry_params)
      redirect_to edit_path(:entry_id => @entry.id)
    else
      render 'edit'
    end
  end

  def destroy
    @entry = current_user.entries.find(params[:entry_id])
    @entry.destroy
    redirect_to root_url
  end

  def show
    @entry = current_user.entries.find(params[:id])
    render 'edit'
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :content)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
    end
end
