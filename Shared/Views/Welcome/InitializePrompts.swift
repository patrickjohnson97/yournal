//
//  InitializePrompts.swift
//  yournal
//
//  Created by Patrick Johnson on 3/28/21.
//

import Foundation

public var prompts : [String] = ["What do I love about my life?", "What do I feel like my life is missing and how can I get more of what I need?", "Where do I want to be in 5 years?", "Who are the people in my life that make me the happiest?", "When am I the happiest version of me?", "What do I love doing?", "What am I afraid to do?", "Can I improve on any of my daily habits?", "What steps am I taking to reach my goals?", "What makes me upset?", "How can I add to my happiness?", "Am I doing all that I can to reach my goals?", "What areas of my life can I improve in?", "What are 5 things I love about myself?", "What are 3 negative mindsets I need to let go of?", "What will I accomplish next year?", "How can I improve my daily routines?", "What is one piece of advice I’d give my future self?", "How can I love myself more daily?", "What can I do to practice more self care throughout the week?", "What are 5 things that make me smile?", "What steps can I take to be the most confident version of myself?", "How can I show others more love and compassion each day?", "Who makes me the happiest?", "What is my number one goal for next year?", "If I could relive one moment what would it be?", "If I could time travel where would I go?", "How would I describe a perfect day?", "If I could be anything in the world, what would I be?", "If I could travel anywhere in the world, where would I go?", "How would I describe my ideal life?", "What is most important to me?", "If I would describe myself, what would I say?", "If my friends were to describe me, what would they say?", "How can I create more positive habits?", "What are 3 things I need to stop doing?", "What are 3 positive things I should start doing?", "What’s on my mind right now?", "What are the top 25 things on my bucket list?", "Who inspires me the most and why?", "When was the last time I laughed until I cried?", "What are 3 things I need to do more of?", "What do I forgive myself for?", "What am I leaving in the past?", "What do I want to take with me into the future?", "What am I grateful for?", "What do I need more of?", "What are my top priorities?", "Is there something I need to change that might be holding me back?", "What are my goals for next month?"]

func initializePrompts(promptViewModel: PromptViewModel){
    for prompt in prompts {
        promptViewModel.addPrompt(value: prompt)
    }
}
