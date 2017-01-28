class EntriesController < ApplicationController
  before_action :logged_in_user #, only: [:create, :edit, :destroy, :update]
  before_action :correct_user #,   only: :destroy

  def create
    @entry = current_user.entries.build(title: '', content: '', tag_list: '')
    if @entry.tag_list.add(params[:tag_list], parse: true) && @entry.save
      redirect_to edit_path(entry_id: @entry.id), remote: false
    else
      render 'static_pages/home'
    end
  end

  def edit
    @entry = current_user.entries.find(params[:entry_id])
  end

  def update
    @entry = current_user.entries.find(params[:id])
    content_plain = CGI.unescapeHTML(ActionView::Base.full_sanitizer.sanitize(
                    entry_params[:content]))

    if @entry.tag_list.add(params[:tag_list], parse: true) &&
       @entry.update_attributes(entry_params.merge(content_plain: content_plain))
       respond_to do |format|
         format.html { render html: 'Saved' }
       end
    else
      redirect_to edit_path(entry_id: @entry.id)
    end
  end

  def destroy
    @entry = current_user.entries.find(params[:entry_id])
    @entry.destroy

    # Reload the tag list, removing unused tags (if any)
    respond_to do |format|
      format.html { render partial: 'shared/tags' }
    end
  end

  def show
  end

  def show_single
    @entry = current_user.entries.find(params[:id])

    respond_to do |format|
      format.html { render partial: 'shared/entry', locals: { entry: @entry } }
    end
  end

  def search
    @entries = filter_by_tag.search(params[:term])

    respond_to do |format|
      format.html { render 'show', layout: false }
    end
  end

  def sort
    @entries = filter_by_tag

    respond_to do |format|
      format.html { render 'show', layout: false }
    end
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :content, :content_plain, :tag_list)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
    end

    def filter_by_tag
      if params[:tag_name] == 'All Entries' || params[:tag_name] == nil
        current_user.entries
      else
        current_user.entries.tagged_with(params[:tag_name])
      end
    end
end
