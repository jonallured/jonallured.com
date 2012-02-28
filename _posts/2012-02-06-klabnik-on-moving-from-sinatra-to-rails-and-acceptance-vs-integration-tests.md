---
layout: post
title: Klabnik on Moving from Sinatra to Rails and Acceptance vs. Integration Tests
published_at: Monday, February 6, 2012
---

I recently had a conversation with fellow Rocketeer [Brian Dunn](https://twitter.com/higgaion) about the difference between Acceptance and Integration testing. I've always been a little fuzzy about what the two terms meant, but Steve Klabnik's post about [moving from Sinatra to Rails](http://blog.steveklabnik.com/posts/2012-01-17-moving-from-sinatra-to-rails) prompted me to finally bring it up.

What he helped me see is that Acceptance and Integration tests are similar in that they are written at a higher level than a Unit test, but Acceptance tests aren't meant to interact with code at all. When you use Cucumber for this level of testing, that means an Integration test might look like this:

	Given a translator that has been assigned a task
	When I navigate to the assignement list
	Then I should see an assignment for that task and translator

And the maybe its defined with something like this:

	Given 'a translator that has been assigned a task' do
	  @translator = Fabricate :translator
	  @task = Fabricate :task
	  @translator.assign @task
	end

That would be a reasonable Integration test for this step, but wouldn't cut it if we were writing an Acceptance test. For that type of test, we'd need to create the Translator, the Task and then assign it using only the interface, maybe something like this:

	Given I create a new translator
	And I fill out the translator creation form
	And I create a new task
	And I fill out the task creation form
	And I create a new assignment
	And I fill out the assignment form
	When I navigate to the assignement list
	Then I should see an assignment for that task and translator

And then you'd have a bunch of work to do to define these steps using only Capybara.

Or something like that, anyway -- the point is that what is one easy step in an Integration test turns into a lot of steps taking nothing for granted in an Acceptance test.

Its no surprise that in the context of moving from Sinatra to Rails, Klabnik tells us that our Acceptance tests are our most valuable tool to make sure our code works the way we intend for it to work. In fact, he suggests evaluating how well your Acceptance tests cover the app and writing a few more of this type of test where you see spotty coverage.

He mentions that he normally writes only happy path Acceptance tests and then uses a term I hadn't heard before: the sad path. Can't believe I hadn't run into that before.

I'm very much a fan of this idea that you should get quick wins and use that momentum to get to bigger problems later. I always find myself wanting to do the hardest stuff last and then when I get to it, I've built up a head of steam and I feel like I get it done better than if I had started it first.

Another thing that jumped out was his note about how Rails and Sinatra have different redirection methods -- I've always been annoyed by this.

Klabnik advises us to resist the urge to simultaneously move code over and convert it to the Rails style -- he'd rather see you move it over with as few modifications as possible, get it working and then refactor.

I've never had to make the move from Sinatra to Rails, but I think his ideas are pretty sound and would try this approach if this did come up in my work.