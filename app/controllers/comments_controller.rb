class CommentsController < ApplicationController
     before_filter :authenticate_user!
  http_basic_authenticate_with name: "sammy1088", password: "Ce66$rio", except: [:new, :create]


     def new
    @comment = Comment.new
    
  end
   def create
        
        if params[:comment_id]
          commentable = Comment.find(params[:comment_id]) 
        elsif params[:link_id]
          commentable = Link.find(params[:link_id])
        elsif params[:job_id]
          commentable = Job.find(params[:job_id])
        elsif params[:event_id]
          commentable = Event.find(params[:event_id])
          elsif params[:bill_id]
          commentable = Bill.find(params[:bill_id])
else
  raise "Comment can't be orphaned"
end

@comment = current_user.comments.create(comment_params.merge(commentable_id: commentable.id, commentable_type: commentable.class.name))

        redirect_to :back
    end
    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
  end
    

  def comment_params
    params.require(:comment).permit(:user_id, :message, :link_id, :comment_id)
  end
end
