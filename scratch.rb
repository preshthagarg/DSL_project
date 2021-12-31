#!/usr/bin/env ruby
# require 'SolidAssert'
# SolidAssert.enable_assertions

def hello(name)
  printf "Hello #{name}"
end
x = [1, 2, 3, 4, 5, 6]
# x.each { |i| print(i * 2) }

class Inator
  attr_accessor :name, :description, :tragic_backstory

  def initialize(_name, _desc, _backstory)
    5
  end

  def monologue(_args)
    puts 'Now I will rule the tri-state area'
  end

  def self_destruct(_args)
    puts 'Kaboom'
  end
end

class Bard
  attr_accessor :name, :cha, :weapon

  def seduce(target); end

  def mock(target); end

  def use(weapon: 'rapier'); end

  def attack(target); end
end

class Tree
  # include SolidAssert
  attr_accessor :label, :branches

  def initialize(label, branches = [])
    @label = label
    # SolidAssert.assert (branches.all? { |b| b.instance_of?(Tree) }), 'All branches must be trees'
    @branches = branches
  end

  def leaf?
    @branches.length.zero?
  end
end

class Link
  # include SolidAssert
  attr_accessor :first, :rest

  @@empty = Empty

  def initialize(first, rest = @@empty)
    @first = first
    # SolidAssert.assert rest.instance_of?(Link) or rest == @@empty
    @rest = rest
  end

  def empty?
    false
  end

  def flatmap(&blk)
    Link.new(blk.call(@first), @rest.flatmap(&blk))
  end

  def flatmap!(&blk)
    @rest = @rest.flatmap if @rest.empty?
    @first = blk.call(@first)
    @rest.flatmap!(&blk)
  end

  def deepmap(&blk)
    return Link.new(@first.deepmap(&blk), @rest.deepmap(&blk)) if instance_of? Link

    blk.call(self)
  end

  def append(item)
    Link.new(@first, @rest.append(item))
  end

  def append!(item)
    if @rest.empty?
      @rest = @rest.append(item)
    else
      @rest.append!(item)
    end
  end

  def to_arr
    [@first] + @rest.to_arr
  end

  def inspect
    to_arr.inspect.sub('[', '<').sub(']', '>')
  end

  def filter(&blk)
    if blk.call(@first)
      Link.new(@first, @rest.filter(&blk))
    else
      @rest.filter(&blk)
    end
  end

  def filter!(&blk)
    if blk.call(@first)
      @first = @rest.first
      @rest = @rest.rest
      @rest.filter!(&blk)
    end
  end

  def reduce; end
  def reduce!; end
end

class Empty < Link
  def self.empty?
    true
  end

  def self.to_arr
    []
  end

  def self.append(item)
    Link.new(item)
  end
end

def binsearch(val, lst, offset = 0)
  midpoint = lst.length.div(2)
  return offset + midpoint if val == lst[midpoint]
  return -1 if lst.length == 1 or lst.length.zero?
  return binsearch(val, lst.slice(midpoint, lst.length), offset + midpoint) if val > lst[midpoint]
  return binsearch(val, lst.slice(0, midpoint), offset) if val < lst[midpoint]
end

class Array
  def my_filter
    acc = []
    each do |x|
      acc << x if yield x
    end
    acc
  end

  def my_map
    acc = []
    each { |x| acc << (yield x) }
    acc
  end

  def to_link
    l = Link.new(self[0])
    slice(1, length).each { |i| l.append!(i) }
    l
  end
end

# print [1, 2, 3].my_map { |i| i * 2 }
# puts [1, 2, 3].each { |x| x * 2 }
x = Link.new(1, Link.new(2, Link.new(3)))

def curry(f, n, acc = [])
  return f.call(*acc) if n.zero?

  lambda do |x|
    return curry(f, n - 1, acc + [x])
  end
end
