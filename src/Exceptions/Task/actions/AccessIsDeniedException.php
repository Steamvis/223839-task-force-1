<?php

namespace Exceptions\Task\actions;

class AccessIsDeniedException extends BaseException
{
    public function __construct($message = null)
    {
        $this->message = $message ?? 'Access is denied';
        parent::__construct($this->message);
    }
}
