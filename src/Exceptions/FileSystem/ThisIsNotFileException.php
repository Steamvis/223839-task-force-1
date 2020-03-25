<?php


namespace Exceptions\FileSystem;

use Exceptions\BaseException;

class ThisIsNotFileException extends BaseException
{
    public function __construct($message = null)
    {
        $this->message = $message ?? 'This is not a file';
        parent::__construct($this->message);
    }
}
