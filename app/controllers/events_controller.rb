class EventsController < ApplicationController

	def index
		
		@events = Event.future.all
		@posts = Post.tagged_with("events").limit(5)
		
  end

end
