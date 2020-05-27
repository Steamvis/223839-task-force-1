<?php

namespace frontend\models\forms;

use frontend\models\Tasks;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use yii\db\ActiveQuery;
use yii\db\Expression;
use yii\helpers\ArrayHelper;

class TasksFilterForms extends Model
{
    const CREATED_TODAY = 24; // HOUR
    const CREATED_WEEK = 7; // DAY
    const CREATED_MONTH = 1; // MONTH
    const ALL_TIME = 0;

    const WITHOUT_RESPONSES = 'withoutResponses';
    const REMOTE_WORK = 'remoteWork';

    public $categories = '';
    public $extraFields = '';
    public int $period = self::CREATED_WEEK;
    public string $search = '';

    public function attributeLabels(): array
    {
        return [
          'categories' => 'Категории',
          'extraFields' => 'Дополнительно',
          'period' => 'Период',
          'search' => 'Поиск по названию'
        ];
    }

    public function rules(): array
    {
        return [
          [['categories', 'extraFields', 'period', 'search'], 'safe'],
        ];
    }

    public static function getPeriodList(): array
    {
        return [
          static::CREATED_TODAY => 'За день',
          static::CREATED_WEEK => 'За неделю',
          static::CREATED_MONTH => 'За месяц',
          static::ALL_TIME => 'За все время'
        ];
    }

    public static function getExtraFieldsList(): array
    {
        return [
          static::WITHOUT_RESPONSES => 'Нет откликов',
          static::REMOTE_WORK => 'Удаленная работа'
        ];
    }

    public function search(array $data): ActiveDataProvider
    {
        $query = Tasks::find()
          ->andWhere(['status' => Tasks::STATUS_NEW])
          ->with(['city', 'category', 'responses'])
          ->orderBy(['created_at' => SORT_DESC]);

        $dataProvider = new ActiveDataProvider(['query' => $query, 'pagination' => ['pageSize' => 5]]);

        if ($this->isLoadWithoutFilters($data)) {
            return $dataProvider;
        }

        $data = $this->getFilterData($data);

        $this->setFilters($query, $data);

        $data = $this->getReadyDataToLoad($query, $data);

        if ($this->validate()) {
            $this->load($data);
        }

        return $dataProvider;
    }

    private function getReadyDataToLoad(ActiveQuery $query, array $data): array
    {
        $accumulated = $data;
        $data = [];
        $data[$this->formName()] = $accumulated;

        return $data;
    }

    private function setFilters(ActiveQuery $query, array $data): void
    {
        $this->setExtraFieldsFilter($query, $data);

        $this->setCategoriesFilter($query, $data);

        $this->setPeriodFilter($query, $data);

        $this->setSearchFilter($query, $data);
    }

    private function setExtraFieldsFilter(ActiveQuery $query, array $data): void
    {
        if (!empty($extraFields = $this->getExtraFields($data))) {
            $extraFieldsFilters = [
              static::WITHOUT_RESPONSES => [$this, 'setWithoutResponsesExtraFieldsFilter'],
              static::REMOTE_WORK => [$this, 'setRemoteWorkExtraFieldsFilter'],
            ];

            foreach ($extraFields as $extraField) {
                if (ArrayHelper::keyExists($extraField, $extraFieldsFilters)) {
                    call_user_func($extraFieldsFilters[$extraField], $query);
                }
            }
        }
    }

    private function setWithoutResponsesExtraFieldsFilter(ActiveQuery $query): void
    {
        $tasksWithoutResponses = Tasks::getTasksResponses()->distinct()->select('task_id')->column();

        $query->andFilterWhere(['NOT IN', 'id', $tasksWithoutResponses]);
    }

    private function setRemoteWorkExtraFieldsFilter(ActiveQuery $query): void
    {
        $query->andWhere(['remoteWork' => 1]);
    }

    private function setCategoriesFilter(ActiveQuery $query, array $data): void
    {
        $query->andFilterWhere(['category_id' => ArrayHelper::getValue($data, 'categories')]);
    }

    private function setPeriodFilter(ActiveQuery $query, array $data): void
    {
        if (($period = (int)ArrayHelper::getValue($data, 'period')) === static::ALL_TIME) {
            return;
        }

        $periods = [
          static::CREATED_TODAY => 'HOUR',
          static::CREATED_WEEK => 'DAY',
          static::CREATED_MONTH => 'MONTH'
        ];

        $date = ArrayHelper::keyExists($period, $periods) ? $periods[$period] : 'MONTH';

        $query->andFilterWhere([
          '>',
          'created_at',
          new Expression("CURRENT_TIMESTAMP - INTERVAL {$period} {$date}")
        ]);
    }

    private function setSearchFilter(ActiveQuery $query, array $data): void
    {
        if (!empty($search = (string)ArrayHelper::getValue($data, 'search'))) {
            $query->andFilterWhere(['LIKE', 'title', $search]);
        }
    }

    private function getExtraFields(array $data): array
    {
        return empty($extraFields = ArrayHelper::getValue($data, 'extraFields')) ? [] : $extraFields;
    }

    private function isLoadWithoutFilters(array $data): bool
    {
        return !ArrayHelper::keyExists($this->formName(), $data);
    }

    private function getFilterData($data): array
    {
        return ArrayHelper::getValue($data, $this->formName());
    }
}
