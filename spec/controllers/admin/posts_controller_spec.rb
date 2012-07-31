require 'spec_helper'

module Enki

  describe Admin::PostsController do

    before do
      controller.stub!(:logged_in?).and_return(true)
    end

    describe 'handling GET to index' do
      before(:each) do
        @posts = [create(:post), create(:post)]
        Post.stub!(:paginated).and_return(@posts)
        
        get :index
      end

      it "is successful" do
        response.should be_success
      end

      it "renders index template" do
        response.should render_template('index')
      end

      it "finds posts for the view" do
        assigns[:posts].should == @posts
      end
    end

    describe 'handling GET to show' do
      before(:each) do
        @post = create(:post)
        
        get :show, :id => @post.to_param
      end

      it "is successful" do
        response.should be_success
      end

      it "renders show template" do
        response.should render_template('show')
      end

      it "finds post for the view" do
        assigns[:post].should == @post
      end
    end

    describe 'handling GET to new' do
      before(:each) do
        @post = build(:post)
        Post.stub!(:new).and_return(@post)
        
        get :new
      end

      it('is successful') { response.should be_success}
      it('assigns post for the view') { assigns[:post] == @post }
    end

    describe 'handling PUT to update with valid attributes' do
      before(:each) do
        @post = mock_model(Post, :title => 'A post')
        @post.stub!(:update_attributes).and_return(true)
        
        Post.stub!(:find).and_return(@post)
      end

      def do_put
        put :update, :id => 1, :enki_post => valid_post_attributes
      end

      it 'updates the post' do
        published_at = Time.now
        @post.should_receive(:update_attributes).with(valid_post_attributes)
        Time.stub!(:now).and_return(published_at)

        do_put
      end

      it 'it redirects to index' do
        do_put
        response.should be_redirect
        response.should redirect_to(admin_posts_path)
      end
    end

    describe 'handling PUT to update with invalid attributes' do
      before(:each) do
        @post = create(:post)
        Post.any_instance.stub(:update_attributes).and_return(false)

        put :update, :id => @post.to_param, :enki_post => {}
      end

      it { should render_template('show') }
      its(:status) { should be 422 }
    end

    describe 'handling POST to create with valid attributes' do
      it 'creates a post' do
        lambda { post :create, :enki_post => valid_post_attributes }.should change(Post, :count).by(1)
      end
    end

    def valid_post_attributes
      {
        'title'      => "My Post",
        'body'       => "hello this is my post",
        'minor_edit' => "0"
      }
    end

    describe 'handling DELETE to destroy' do
      before(:each) do
        @post = Post.new
        @post.stub!(:destroy_with_undo)
        Post.stub!(:find).and_return(@post)
      end

      def do_delete
        delete :destroy, :id => 1
      end

      it("redirects to index") do
        do_delete
        response.should be_redirect
        response.should redirect_to(admin_posts_path)
      end

      it("deletes post") do
        @post.should_receive(:destroy_with_undo)
        do_delete
      end
    end

    describe 'handling DELETE to destroy, JSON request' do
      before(:each) do
        @post = Post.new(:title => 'A post')
        @post.stub!(:destroy_with_undo).and_return(mock_model(UndoItem, :description => 'hello'))
        Post.stub!(:find).and_return(@post)
      end

      def do_delete
        delete :destroy, :id => 1, :format => 'json'
      end

      it("deletes post") do
        @post.should_receive(:destroy_with_undo).and_return(mock_model(UndoItem, :description => 'hello'))
        
        do_delete
      end

      it("renders json including a description of the post") do
        do_delete
        
        JSON.parse(response.body)['undo_message'].should == 'hello'
      end
    end
  end

  describe Admin::PostsController, 'with an AJAX request to preview' do
    before(:each) do
      controller.stub!(:logged_in?).and_return(true)
      @post = build(:post)
      Post.should_receive(:build_for_preview).and_return(@post)
      
      xhr :post, :preview, :enki_post => {
        :title        => 'My Post',
        :body         => 'body',
        :tag_list     => 'ruby',
        :published_at => 'now'
      }
    end

    it "assigns a new post for the view" do
      assigns(:post).should == @post
    end
  end
end