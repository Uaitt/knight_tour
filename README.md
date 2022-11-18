# knight_tour
Solution to the Knight's Tour Problem written in Ruby and tested with RSpec.

## Overview
[Knight's tour](https://en.wikipedia.org/wiki/Knight%27s_tour) refers to a sequence of moves that a knight can make on a [chessboard](https://en.wikipedia.org/wiki/Chessboard) such that, starting from a given position, it can reach any possible square, visiting every cell exactly once.

The knight's tour problem is the mathematical problem of finding a knight's tour, given the starting and ending position of the path.

## Usage
To run this project, first [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repository on your local machine.

Move to the project directory
```
$ cd knight_turn
```

Launch the application
```
$ ruby lib/main.rb

```

Follow the instructions in the terminal to correctly use this script.

## Tests
You can launch the whole test suite
```
$ rspec spec/
```

Or launch the test only for one class
```
$ rspec spec/class_spec.rb
```

## Built with 
1. Ruby 3.1.2
2. Rspec 3.11
   * rspec-core 3.11.0
   * rspec-expectations 3.11.1
   * rspec-mocks 3.11.1
   * rspec-support 3.11.1
