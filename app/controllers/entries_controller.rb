class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @entry = current_user.entries.build(title: '', content: '', tag_list: '')
    if @entry.tag_list.add(params[:tag_list], parse: true) && @entry.save
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
    if @entry.tag_list.add(params[:tag_list], parse: true) && @entry.update_attributes(entry_params)
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
    filter_by_tag
  end

  def sort
    filter_by_tag

    respond_to do |format|
      format.html { render 'show', :layout => false }
    end
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :content, :tag_list)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
    end

    def filter_by_tag
      if params[:tag_name] == 'All'
        @entries = current_user.entries
      else
        @entries = current_user.entries.tagged_with(params[:tag_name])
      end
    end
end
