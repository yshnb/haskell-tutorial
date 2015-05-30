<?php
abstract class Maybe {
    abstract public function get();

    public function bind($callable)
    {
        $value = $callable($this->get());

        // ここで結合のルールを決めている
        if (isset($value)) {
            return new Just($value);
        } else {
            return new Nothing();
        }
    }
}

class Just extends Maybe
{
    private $value;

    public function __construct($value) // return相当
    {
        $this->value = $value;
    }

    public function get()
    {
        return $this->value;
    }
}

class Nothing extends Maybe
{
    public function __construct() // return相当
    {
    }

    public function get()
    {
        return null;
    }
}

// usage
$maybeValue = new Just(6);
echo get_class($maybeValue)."\n"; // Just

$maybeValue = $maybeValue->bind(function($val) {
    return ($val % 2 == 0) ? $val / 2 : null;
});
echo get_class($maybeValue)."\n"; // Just

$maybeValue = $maybeValue->bind(function($val) {
    return ($val % 2 == 0) ? $val / 2 : null;
});
echo get_class($maybeValue)."\n"; // Nothing
