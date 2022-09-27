# Cachex

Simple cache application made with GenServer and ETS.

**Project made for study purposes only.**

If you want to clone the project to run locally you'll need Elixir 1.14. Run the command bellow:

```zsh
$ asdf install
```

And then you'll need to run:

```zsh
$ mix deps.get
```

And then you should be able to start your local application:

```zsh
$ iex -S mix
```

## How to use it

### Insert

First of all you need to insert a key in your cache, so let's do it:

```zsh
$ iex> Cachex.insert(:some_key, :some_value)
{:ok, {:some_key, {:some_value, 1664290646}}}
$ iex> Cachex.insert(:some_key_1, :some_value, 120)
{:ok, {:some_key_1, {:some_value, 1664290624}}}
```

As you can see above you can insert a key by calling `insert/2` or `insert/3`. The third parameter is the TTL, if you don't pass it a default value is used (300s aka 5 minutes).

### Get

Getting a key value is very simple:

```zsh
$ iex> Cachex.get(:some_key)
{:ok, :some_value, -35}
```

It should return your key value only if your key TTL is still valid, if it's not it should return expired. The negative number on the return of the function it's the time to leave in seconds. So the key above will expire in 35seconds. If we wait 35seconds and try to get it again the return will be:

```zsh
$ iex> Cachex.get(:some_key)
{:error, :expired}
```

Okay, what if we try to get it again? Let's see:

```zsh
$ iex> Cachex.get(:some_key)
{:error, :not_found}
```

The first info after the expiration is that the key doesn't exist and the second is that the key is not found. Of course it's because it doesn't exist anymore.

Future feature I could do is handle expired keys automatic without needing trying to get it first to delete it from the ETS table.

### Delete

Yes, you can delete a key manually if you want it:

```zsh
$ iex> Cachex.delete(:some_key)
true
```

The function returns a boolean because `:ets.delete/2` returns a boolean if everything gone ok. Future feature I could do is handle the return with somenthing like {:ok, _something} | {:error, _something}. 

## Tests

If you want to run the tests you only need to run the command below:

```zsh
$ mix test
```