<?php


namespace Src\Exceptions\FileSystem;

use Src\Exceptions\BaseException;

class ThisIsNotDTOException extends BaseException
{
    public function __construct($message = null)
    {
        $this->message = $message ?? 'It is not DTO';
        parent::__construct($this->message);
    }
}
