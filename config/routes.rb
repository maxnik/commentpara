ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'chapters', :action => 'index'

  map.login '/login', :controller => 'sessions', :action => 'new'
  map.session '/session', :controller => 'sessions', :action => 'create'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.resources :chapters do |chapter|
    # GET comments for commentable in chapter
    chapter.show_comments '/comments/:commentable_id', :controller => 'comments', :action => 'show',
                          :name_prefix => nil, :conditions => {:method => :get}
    # create new comment for commentable in chapter
    chapter.create_comment '/comments/:commentable_id', :controller => 'comments', :action => 'create', 
                           :name_prefix => nil, :conditions => {:method => :post}
  end
  map.resources :comments, :only => [:index, :destroy]

  map.preview '/preview', :controller => 'service', :action => 'preview'
end
