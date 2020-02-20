<?php

namespace src\Logic\actions;


use src\error\AccessIsDeniedException;

class ActionCancel extends Action
{
    public function getPublicName(): string
    {
        return 'Отменить';
    }

    public function checkRights(int $customerID, int $performerID, int $currentUserID): bool
    {
        if ($customerID !== $currentUserID) {
            throw new AccessIsDeniedException('Access is denied');
        }

        return true;
    }
}
