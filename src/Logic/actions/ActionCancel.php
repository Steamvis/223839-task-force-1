<?php

namespace src\Logic\actions;


class ActionCancel extends Action
{
    public function getPublicName()
    {
        return 'Отменить';
    }

    public static function getInnerName()
    {
        return parent::getInnerName();
    }

    public function checkRights($customerID, $performerID, $currentUserID, $taskStatus)
    {
        return $performerID !== $currentUserID && $customerID === $currentUserID && $taskStatus === 0;
    }
}
