<?php
/**
 * 2007-2015 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/osl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2015 PrestaShop SA
 * @license   http://opensource.org/licenses/osl-3.0.php Open Software License (OSL 3.0)
 * International Registered Trademark & Property of PrestaShop SA
 */
namespace PrestaShop\PrestaShop\Adapter\Admin;

use PrestaShopBundle\Service\Hook\RenderingHookEvent;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

/**
 * Adds listeners to renderhook Twig function, to let adding legacy helpers like Kpi, etc...
 *
 * @package PrestaShop\PrestaShop\Adapter\Admin
 */
class LegacyBlockHelperSubscriber implements EventSubscriberInterface
{
    /**
     * Returns an array of event names this subscriber wants to listen to.
     *
     * @return array The listeners array
     */
    public static function getSubscribedEvents()
    {
        return array(
            'legacy_block_kpi' => array('renderKpi', 0)
        );
    }

    /**
     * Renders a Kpi block for a given legacy controller name.
     *
     * @param RenderingHookEvent $event
     * @throws \Exception
     */
    public function renderKpi(RenderingHookEvent $event)
    {
        if (!array_key_exists('kpi_controller', $event->getHookParameters())) {
            throw new \Exception('The legacy_kpi hook need a kpi_controller parameter (legacy controller full class name).');
        }
        $controller = $event->getHookParameters()['kpi_controller'];

        $controller = new $controller();

        $event->setContent($controller->renderKpis());
    }
}
